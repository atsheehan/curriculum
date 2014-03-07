def most_common(string)
  freqs = Hash.new(0)

  string.downcase.tr(",.?!",'').split(' ').each do |word|
    freqs[word] += 1
  end

  max_freq = freqs.max_by{|k,v| v }.reverse[0]
  freqs.find_all{|k,v| v == max_freq }.map(&:first)
end

