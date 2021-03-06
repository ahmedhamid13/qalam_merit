require "rails/generators"

module Merit
  module Generators
    class MeritGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      def inject_merit_content
        if model_exists?
          inject_into_class(model_path, class_name, "  ### END ###\n\n")
          inject_into_class(model_path, class_name, "  has_many :created_badges, class_name: 'Merit::Badge', :dependent => :destroy\n")
          inject_into_class(model_path, class_name, "  has_many :assigned_badges, through: :sash, source: :badges, :dependent => :destroy\n")
          inject_into_class(model_path, class_name, "  belongs_to :sash, foreign_key: 'sash_id', class_name: 'Merit::Sash', :dependent => :destroy\n")
          inject_into_class(model_path, class_name, "  has_merit\n")
          inject_into_class(model_path, class_name, "  ### QALAM_MERIT ###\n")

          inject_into_class(course_path, "Course", "  ### END ###\n\n")
          inject_into_class(course_path, "Course", "  has_many :badges_sashes, class_name: 'Merit::BadgesSash', dependent: :destroy\n")
          inject_into_class(course_path, "Course", "  has_many :score_points, class_name: 'Merit::QalamScore::Point', dependent: :destroy\n")
          inject_into_class(course_path, "Course", "  ### QALAM_MERIT ###\n")
        end
      end

      def run_active_record_generators
        invoke 'merit:active_record:merit'
      end

      private

      def model_exists?
        File.exist? File.join(destination_root, model_path)
      end

      def model_path
        @model_path ||= File.join('app', 'models', "#{file_path}.rb")
      end

      def course_path
        @course_path ||= File.join('app', 'models', "course.rb")
      end
    end
  end
end
