# frozen_string_literal: true

unless Rails.env.production?
  desc 'Run ESLint'
  task :eslint do
    system('yarn', 'run', 'lint')
  end
end
