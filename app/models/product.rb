class Product < ApplicationRecord
  def cached_image_url
    Rails.cache.fetch("product_image_#{id}", expires_in: 1.day) do
      img_url
    end
  end
end
