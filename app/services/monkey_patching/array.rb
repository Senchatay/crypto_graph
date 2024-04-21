class Array
  def split_by_parity
    partition.with_index do |_, i|
      i.even?
    end
  end
end
