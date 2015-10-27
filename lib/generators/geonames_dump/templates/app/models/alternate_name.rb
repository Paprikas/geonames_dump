class Geonames::AlternateName < ActiveRecord::Base
  validates_uniqueness_of :alternate_name_id
  before_save :set_alternate_name_first_letters

  belongs_to :feature,
    :inverse_of => :alternate_names,
    :primary_key => 'geonameid',
    :foreign_key => 'geonameid'

  ##
  # default search (by alternate name)
  #
  scope :geo_search, lambda { |q|
    by_alternate_name_featured(q)
  }

  ##
  # search by isolanguage code
  #
  scope :by_isolanguage, lambda { |q|
    where("isolanguage = ?", q)
  }

  ##
  # search prefered names
  #
  scope :prefered, lambda {
    where(is_preferred_name: true)
  }

  ##
  # search by name for available features
  #
  scope :by_alternate_name_featured, lambda { |q|
    joins(:feature).by_alternate_name(q).where(Geonames::Feature.arel_table[:id].not_eq(nil))
  }

  ##
  # search by name
  #
  scope :by_alternate_name, lambda { |q|
    ret = self.all
    ret = ret.where("alternate_name_first_letters = ?", q[0...3].downcase)
    ret = ret.where("alternate_name LIKE ?", "#{q}%")
  }

  protected

  ##
  # Set first letters of name into index column
  #
  def set_alternate_name_first_letters
    self.alternate_name_first_letters = self.alternate_name[0...3].downcase unless self.alternate_name.nil?
  end

end
