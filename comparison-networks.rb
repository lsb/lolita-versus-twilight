require 'peach'

class Array
  def pmax_by(&b)
    return self.first if self.size < 2
    return b[self.first,self.last] if self.size == 2
    (0 .. (self.size-1)/2).pmap(self.size / 2) {|i| self.slice(i*2,2).pmax_by(&b) }.pmax_by(&b)
  end

  def psort(verbose=false, &b)
    # Batcher's sort, Knuth 5.2.2M .
    sorted = self.slice(0,size)
    t = Math.log2(size).ceil
    p = 1 << (t-1)
    STDERR.puts("\n===") if verbose
    while p > 0
      q = 1 << (t-1)
      r = 0
      d = p
      while d > 0
        (0 .. (size-d-1)).peach(50) {|i|
          if (i&p) == r
            STDERR.print("#{i}-/-#{i+d} ") if verbose
            sorted[i], sorted[i+d] = sorted[i+d], sorted[i] if b[sorted[i], sorted[i+d]]
          end
        }
        STDERR.puts("\n===") if verbose
        d = q-p
        q >>= 1
        r = p
      end
      p >>= 1
    end
    sorted
  end
end
