require 'digest'
require "attr_extras"

module XYZ
  class Namer
    MAX_TITLE_LENGTH = 9

    static_facade :xyz_filename,
      :target

    # File format:
    # [day of month zero-padded][three-letter prefix] \
    # _[kind]_[age_if_kind_personal]_[target.id] \
    # _[8 random chars]_[10 first chars of title].jpg
    def xyz_filename
      parts = []
      parts << "#{zero_padded_day_of_month}#{category_prefix}#{kind}"
      parts << age if target.personal?
      parts << target_id
      parts << random_characters
      parts << truncated_title

      parts.join("_") + ".jpg"
    end

    private

    def zero_padded_day_of_month
      target.publish_on.strftime("%d")
    end

    def category_prefix
      target.xyz_category_prefix
    end

    def kind
      target.kind.gsub("_", "")
    end

    def age
      zero_prefix target.age || 0
    end

    def target_id
      target.id
    end

    def random_characters
      Digest::SHA1.hexdigest(rand(10000).to_s)[0,8]
    end

    def truncated_title
      cleaned_title = target.title.downcase.gsub(/[^\[a-z\]]/, '')
      truncate_to = [ MAX_TITLE_LENGTH, cleaned_title.length ].min
      cleaned_title[0..truncate_to]
    end

    def zero_prefix(number)
      "%03d" % (number)
    end
  end
end
