class Public::SearchesController < ApplicationController

  def search
    @model = params["model"]
    @content = params["content"]
    @method = params["method"]
    @records = search_for(@model, @content, @method)
  end

  private

  def search_for(model, content, method)
    if model == 'user'
      if method == 'perfect'
        User.where(name: content)
      else
        User.where('name LIKE ?', '%' + content + '%')
      end
    elsif model == 'post_image'
      if method == 'perfect'
        PostImage.where(name: content)
      else
        PostImage.where('name LIKE ?', '%' + content + '%')
      end
    end
  end
end
