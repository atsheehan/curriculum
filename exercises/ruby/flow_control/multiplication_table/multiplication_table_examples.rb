# Part 1

# Example 1

def multiplication_table
  1.upto(12) do |x|
    1.upto(12) do |y|
      val = x * y

      if y == 12
        print "#{val}\n"
      else
        print "#{val}\t"
      end
    end
  end
end

## Example 2

def multiplication_table
  (1..12).each do |x|
    (1..12).each do |y|
      val = x * y

      if y == 12
        print "#{val}\n"
      else
        print "#{val}\t"
      end
    end
  end
end

## Example 3

def multiplication_table
  x = 1
  while x <= 12
    y = 1

    while y <= 12
      val = x * y

      if y == 12
        print "#{val}\n"
      else
        print "#{val}\t"
      end

      y += 1
    end

    x += 1
  end
end

#############################################################################

# Part 2

## Example 1

def multiplication_table(size=12)
  1.upto(size) do |x|
    1.upto(size) do |y|
      val = x * y

      if y == size
        print "#{val}\n"
      else
        print "#{val}\t"
      end
    end
  end
end

## Example 2

def multiplication_table(size=12)
  (1..size).each do |x|
    (1..size).each do |y|
      val = x * y

      if y == size
        print "#{val}\n"
      else
        print "#{val}\t"
      end
    end
  end
end

## Example 3

def multiplication_table(size=12)
  x = 1
  while x <= size
    y = 1

    while y <= size
      val = x * y

      if y == size
        print "#{val}\n"
      else
        print "#{val}\t"
      end

      y += 1
    end

    x += 1
  end
end
