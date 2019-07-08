# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    file do
      file_path = Rails.root.join('spec', 'support', 'attachments', 'image.png')
      Rack::Test::UploadedFile.new(file_path, 'image/png')
    end

    user
  end
end
