class MergeTwoStrings
  # @param {String} word1
  # @param {String} word2
  # @return {String}
  def merge_alternately(word1, word2)
    merged_string = ""
    shorter_string_length = [word1.length, word2.length].min
    longer_string = word1.length > word2.length ? word1 : word2

    (0...shorter_string_length).each do |index|
      word1_char = word1[index]
      word2_char = word2[index]
      merged_string << (word1_char + word2_char)
    end

    if word1.length != word2.length
      merged_string << longer_string.slice(shorter_string_length, longer_string.length)
    end

    merged_string
  end
end