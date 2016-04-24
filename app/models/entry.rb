class Entry < ActiveRecord::Base
  belongs_to :feed
  validates :atom_id, uniqueness: {scope: :feed_id}
  validates :url, uniqueness: :scope {:title}
	
  default_scope {
		order('created_at DESC')
	}
  
  def self.search(search)
    where("title @@ ?", search)
  end
  
  def self.deduplicate
    grouped = all.group_by { |entry| entry.url }
    grouped.values.each do |entry_urls|
      first_one = entry_urls.shift
      entry_urls.each { |dup| dup.destroy }
    end
  end
  
  scope :indexlimit, -> {order('updated_at DESC').limit(250)}
  scope :searchlimit, -> {order('updated_at DESC').limit(300)}
  scope :lastfewdays, -> {where(:created_at => 10.days.ago..DateTime.now.in_time_zone).limit(300)}
  scope :world_all, -> {joins(:feed).merge(Feed.world_all)}
  scope :spain_all, -> {joins(:feed).merge(Feed.spain_all)}
  scope :teaser_limit, -> {order('updated_at DESC').limit(10)}
  
  scope :cincodias, -> {where('url LIKE ?', '%cincodias%')}
  scope :abc, -> {where('url LIKE ?', '%abc.es%')}
  scope :antenatres, -> {where('url LIKE ?', '%antena3%')}
  scope :cope, -> {where('url LIKE ?', '%cope%')}
  scope :efe, -> {where('url LIKE ?', '%efe%')}
  scope :elconfidencial, -> {where('url LIKE ?', '%elconfidencial.com%')}
  scope :elconfidencialdigital, -> {where('url LIKE ANY (array[?])', ['%elconfidencialdigital%', '%monarquiaconfidencial%', '%religionconfidencial%', '%elconfidencialautonomico%'])}
  scope :eldiario, -> {where('url LIKE ?', '%eldiario%')}
  scope :eleconomista, -> {where('url LIKE ?', '%eleconomista%')}
  scope :elespanol, -> {where('url LIKE ?', '%elespanol%')}
  scope :elmundo, -> {where('url LIKE ?', '%elmundo%')}
  scope :elpais, -> {where('url LIKE ?', '%elpais%')}
  scope :elperiodico, -> {where('url LIKE ?', '%elperiodico%')}
  scope :europapress, -> {where('url LIKE ?', '%europapress%')}
  scope :expansion, -> {where('url LIKE ?', '%expansion%')}
  scope :infolibre, -> {where('url LIKE ?', '%infolibre%')}
  scope :lasexta, -> {where('url LIKE ?', '%lasexta%')}
  scope :larazon, -> {where('url LIKE ?', '%larazon%')}
  scope :lavanguardia, -> {where('url LIKE ?', '%lavanguardia%')}
  scope :libertaddigital, -> {where('url LIKE ?', '%libertaddigital%')}
  scope :ondacero, -> {where('url LIKE ?', '%ondacero%')}
  scope :publico, -> {where('url LIKE ?', '%publico%')}
  scope :ser, -> {where('url LIKE ?', '%cadenaser%')}
  scope :telecinco, -> {where('url LIKE ?', '%telecinco%')}
  scope :tve, -> {where('url LIKE ?', '%rtve%')}
  scope :vozpopuli, -> {where('url LIKE ?', '%vozpopuli%')}

end