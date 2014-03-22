require "spec_helper"

describe Radar::Rss do

  let(:setting) {
    RadarSetting.create(url: "http://netzhansa.blogspot.com/feeds/posts/default?alt=rss")
  }

  it "should parse an rss feed" do
    events = Radar::Rss.new(setting).next_events
    expect(events.count).to eq(4)

    event = events[1]
    expect(event[:id]).to eq("tag:blogger.com,1999:blog-3022969446495862761.post-1992542315195053831")
    expect(event[:url]).to eq("http://netzhansa.blogspot.com/2012/08/lparallel-and-how-i-was-thinking-too.html")
    expect(event[:title]).to eq("lparallel and how I was thinking too complicated")
    expect(event[:description]).to eq((<<EOF
<p>
  Yesterday, I posted
  a <a href="http://netzhansa.blogspot.de/2012/08/using-lparallel-to-utilize-multiple.html">short
  article</a> that showed how I used lparallel to speed up a lengthy
  computation by reading input data files in parallel.  A few readers
  responded, and the response from James M. Lawrence, who is the
  author of lparallel, is reproduced here because it contains source
  code that can't be properly formatted in blogspot comments (any
  suggestions regarding something better?).
</p>
<blockquote>
  [citing James M. Lawrence]<br/>
  Here is a map-reduce-style version:
<pre>
(defun slurp-alist (hash-table alist)
  (loop
    :for (key . data) :in alist
    :do (setf (gethash key hash-table) data))
  hash-table)

(defun load-files-in-parallel (pathnames)
  (flet ((parse (pathname)
           (let ((result nil))
             (read-and-parse-file
              pathname
              (lambda (key data)
                (push (cons key data) result)))
             result)))
    (reduce #'slurp-alist
            (lparallel:pmap 'vector #'parse pathnames)
            :initial-value (make-hash-table))))
</pre>
  <p>
    The benefit here is that worker threads do not have to contend for
    a queue lock. A possible drawback is that the key-data pairs
    survive until the final reduce, whereas the pairs have a shorter
    lifetime when passed through a queue. Of course performance will
    depend upon the scale and shape of the data.
  </p>
  <p>
    Benchmarks with early versions of lparallel showed better
    performance with a vector-based queue, however since then I found
    a simple cons-based queue to be generally faster, which is
    currently the default. There is still a compile-time option to get
    the vector-based queue, and unless that is enabled the number
    passed to make-queue is ignored. In other words, the 10000 is a
    lie :)
  </p>
</blockquote>
<p>
  Motivated by James' reply, I spent some time to find out how the
  process could be further optimized.  The idea to have the workers
  cons up the data and then collect all data into the hash table at
  the end of the operation reduced the run time for my application by
  some 30%, which is not bad.
</p>
<p>
  A comment from Max Mikhanosha on G+ suggested that I could avoid the
  queue and directly use a thread safe hash table.  It is a little
  embarrassing that I assumed that I could not write hash tables from
  multiple threads.  Both CCL's and SBCL's hash tables provide for
  thread safe modes, so there is no point in tunneling the data
  through a queue.
</p>
<p>
  As I am using CCL, I tried different values for the :SHARED keyword
  argument to MAKE-HASH-TABLE.  The default is :LOCK-FREE, which makes
  hash tables thread safe without requiring the grabbing of a lock for
  each operation.  Other permitted values are T, which locks the table
  for each access, or NIL for thread-unsafe hash tables.
</p>
<p>
  I found that when writing to the hash table directly from the file
  readers, :SHARED T would give me the best performance.  With that
  option, my code ran another 10% faster than with consing up the file
  results and then processing all the lists at the end.
</p>
<p>
  lparallel is a great example how Common Lisp is an extensible
  language.  The operators provided by it seamlessly integrate
  parallel programming into the language, and with the help of my
  readers, the code that I originally posted now became very small:
  <pre>(defun load-files-in-parallel (pathnames)
  (let ((hash-table (make-hash-table :shared t)))
    (lparallel:pmap nil
                    (lambda (pathname)
                      (read-and-parse-file pathname
                                           (lambda (key data)
                                             (setf (gethash key hash-table)
                                                   data))))
                    pathnames)
    hash-table))</pre>
</p>
<p>
  Look, Ma!  All I needed was pmap!
</p>
EOF
                                      ).strip
                                     )
  end

  it "should return everything that is newer than last_processed" do
    setting.last_processed = Date.new(2010,1,1)
    events = Radar::Rss.new(setting).next_events
    expect(events.count).to eq(25)
  end

end
