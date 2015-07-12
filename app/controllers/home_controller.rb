class HomeController < ApplicationController
  def index
    @beispiele = Beispiel.last([Beispiel.count, 3].min)
    @neuigkeiten = Neuigkeit.accessible_by(current_ability, :show).limit(10)
    if Thema.count>0
    t=YAML.load_file("#{::Rails.root.to_s}/config/start_topic.yml")
    @rubriken= Rubrik.accessible_by(current_ability, :show)

    params[:month]= Date.today.month if params[:month].nil?
    params[:year]= Date.today.year if params[:year].nil?
        
    @calentries= (@rubriken.map {|r| r.calendar}).collect(&:calentries).flatten.select {|c| c.object !=nil}

    @starttopic= @themen = Thema.where(:id=>t).first
    else
      @starttopic=@themen = nil
    end
    @stickythemen = Thema.where(:sticky_startpage=>true)
  end
  def dev

  end
  def kontakt
    t=YAML.load_file("#{::Rails.root.to_s}/config/contact_topic.yml")
    @themen = Thema.where(:id=>t)
  end
  def treeview 
    authorize! :doadmin, User
    @themengruppen = Themengruppe.order(:priority).reverse
    @themengruppen += Themengruppe.intern.order(:priority).reverse

  end
  def intern
    authorize! :seeintern, User
    @neuigkeiten = Neuigkeit.intern.recent
    @themengruppen=Themengruppe.intern.order(:priority).reverse
  end
  def admin
    authorize! :doadmin, User
    t=YAML.load_file("#{::Rails.root.to_s}/config/contact_topic.yml")
    @kontaktthemen = Thema.where(:id=>t)

  end
  def log
    authorize! :doadmin, User
    lines = params[:lines]
    if Rails.env == "production"
      @logs = `tail -n #{lines} log/production.log | grep  -v 'actionpack\\|railties\\|activesupport\\|::Translation'`
    else
      @logs = `tail -n #{lines} log/development.log | grep -v 'actionpack\\|railties\\|activesupport\\|::Translation'`
    end
    
  end
  def startdev
  render 'setup_fetsite_dev'
  end
  def linksnotimplemented
  render 'links_notimplemented'
  end

  def search
  
    unless params['query'].nil? || params['query'].empty?
      @results = Sunspot.search Neuigkeit,Rubrik, Fetprofile, Thema, Themengruppe, Lva, Studium, Modul, Modulgruppe, Gremium, Document do
        fulltext params['query']
      end
      @neuigkeiten=[];
      if can?(:showintern, Neuigkeit)
        #@neuigkeiten=Neuigkeit.search(params['query'])
      else
       # @neuigkeiten =Neuigkeit.search(params['query']).public
      end
      @res=[]
      @results.results.each do |r|
      @res << r if can?(:show,r)
      end

  #    @fetprofiles = Fetprofile.search(params['query'])
      @fetprofiles=[]
     # if can?(:showintern, Neuigkeit)
     #   @themen=Thema.search(params['query'])
     # else
     #   @themen=Thema.search(params['query']).public
     # end
  @themen=[]
      
    else
      @neuigkeiten=[]
      @fetprofiles=[]
      @themen=[]
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  def language
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to :root
  end
  def choose_contact_topics
    authorize! :doadmin, User
    t=YAML.load_file("#{::Rails.root.to_s}/config/contact_topic.yml")
    unless params[:themen].nil?
    t=([t].flatten+params[:themen]).uniq
      end
    unless params[:rmthema].nil? 
      t=t-[params[:rmthema]]
    end
    File.open("config/contact_topic.yml",'w'){|f|  f.write(t.to_yaml)} 
    redirect_to admin_home_index_path
  end

end
