require 'digest'

module XYZ
  module Namer

    def self.xyz_filename(target)
      filename = ""

      # Day of month zero-padded.
      filename << target.publish_on.strftime("%d")

      # Three-letter prefix.
      filename << target.xyz_category_prefix

      # Kind.
      filename << target.kind.gsub("_", "")

      # Zero-padded age if personal.
      filename << "_%03d" % (target.age || 0) if target.personal?

      filename << "_#{target.id}"

      # Random chars.
      filename << "_#{Digest::SHA1.hexdigest(rand(10000).to_s)[0, 8]}"

      # Title prefix.
      truncated_title = target.title.downcase.gsub(/[^\[a-z\]]/, "")
      filename << "_#{truncated_title[0..9]}"

      filename << ".jpg"

      filename
    end

  end
end
