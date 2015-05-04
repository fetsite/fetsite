class CrawlerController < ApplicationController

  def index
    authorize! :doadmin, User
    
    @crawlobjs=Crawlobject.where(:objtype=>5).order(:published_at).reverse_order
  end
  def load_attachments
    authorize! :doadmin, User
    
    c = Crawlobject.find(params[:id])
    if c.has_attachments?
    c.load_attachments
    end
    respond_to do |format|
      format.html {redirect_to c.something}
      format.js
    end
  end
  def move_to_news
    authorize! :doadmin, User
        
    co=Crawlobject.find(params[:id])
    if co.objtype == 5
      co.move_to_neuigkeit(User.find(Rails.configuration.crawlconfig[5]["user_id"]), Rubrik.find(Rails.configuration.crawlconfig[5]["rubrik_id"]))
      redirect_to co.something
    end
  end
end
