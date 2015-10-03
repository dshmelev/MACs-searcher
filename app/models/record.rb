class Record < ActiveRecord::Base
  self.table_name = "history_text"
  default_scope { order('id DESC') }
  has_one :item, :primary_key => "itemid", :foreign_key => "itemid" 
  has_one :host, :through => :item
  validates :item, presence: true
  validates :host, presence: true

  def updated_at
    Time.at(self.clock)
  end

  def self.find_by_value (value)
    self.where('value like ?', "%#{value}%").
         first
  end
  def next
    rec = self.class.where('value = ?', value).
                     where('itemid <> ?',  itemid).
                     where('id < ?',       id).first
    raise ActiveRecord::RecordNotFound if rec.nil?
    return rec
  end
  def prev
    rec = self.class.where('value = ?', value).
                     where('itemid <> ?',  itemid).
                     where('id > ?',       id).first
    raise ActiveRecord::RecordNotFound if rec.nil?
    return rec
  end
  def params
    ActionController::Parameters.new({
      id: self.id,
      host: self.host.name[/^([\w-]+)/],
      item: self.item.name[/(\d+)/],
      clock: Time.at(self.clock).strftime("%d-%m-%Y %H:%M:%S")
    })
  end
end

class Item < ActiveRecord::Base
  self.inheritance_column = :_type_disabled
  has_one :host, :primary_key => "hostid", :foreign_key => "hostid"
end
class Host < ActiveRecord::Base
end
