module Merit::Models::ActiveRecord
  class QalamScore < ActiveRecord::Base
    self.table_name = :merit_scores
    belongs_to :sash
    has_many :score_points,
             dependent: :destroy,
             class_name: 'Merit::QalamScore::Point'

    def points
      score_points.group(:score_id).sum(:num_points).values.first || 0
    end

    class Point < ActiveRecord::Base
      belongs_to :score, class_name: 'Merit::QalamScore'
      has_one :sash, through: :score
      has_many :activity_logs,
               class_name: 'Merit::ActivityLog',
               as: :related_change
      delegate :sash_id, to: :score
    end
  end
end

class Merit::QalamScore < Merit::Models::ActiveRecord::QalamScore; end
class Merit::QalamScore::Point < Merit::Models::ActiveRecord::QalamScore::Point; end
