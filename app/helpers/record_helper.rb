module RecordHelper
    def record_id_gen(*records, prefix: nil)
        tes = records.map do |r|
            dom_id(r, prefix)
        end.join('_')
    end
end