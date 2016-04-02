class AddBlogToSource < ActiveRecord::Migration
  def change
    add_column :sources, :blog, :string
  end
end
