# -*- coding: utf-8 -*-
class NeuigkeitenController < ApplicationController
  
  before_filter :load_toolbar_elements, :only=>[:show,:find_link]
  before_filter :load_toolbar_elements_edit, :only=>[:edit]
 


  load_and_authorize_resource
  def default_url_options
    super
#    super.merge({host: request.host_with_port})
  end
  def show
    @neuigkeit = Neuigkeit.find(params[:id])
    @rubrik = @neuigkeit.rubrik    
    @questions = @neuigkeit.questions.accessible_by(current_ability,:show)
    if can?(:shownonpublic, Rubrik)
      @rubriken = Rubrik.all
    else
      @rubriken = Rubrik.where(:public=>true)
    end   
    
    if  !params[:version].nil? && can?(:showversions, Neuigkeit)
      @neuigkeit.assign_attributes(@neuigkeit.translation.versions.reverse[params[:version].to_i].reify.attributes.select{|k,v| @neuigkeit.translated_attribute_names.include? k.to_sym })
    end 
    @calentries1=@neuigkeit.calentries
    respond_to do |format|
      format.html 
      format.js
    end
    
  end
  
  def new
    @neuigkeit = Neuigkeit.new
    @rubrik=Rubrik.find(params[:rubrik_id]) unless params[:rubrik_id].nil?
    @neuigkeit.author=current_user
    @neuigkeit.rubrik=@rubrik unless @rubrik.nil?
    @calentries= [Calentry.new] 

  end
  def add_calentry
    @neuigkeit=Neuigkeit.find(params[:id])
    if params[:calentry_id].nil?
      ce = Calentry.new(:start=>Time.now, :ende=>1.hour.from_now, :typ=>1, :calendar=>@neuigkeit.rubrik.calendar)
    else
      ce = Calentry.find(params[:calentry_id])
    end
    @calentry=ce 
    ce.object=@neuigkeit
    @neuigkeit.calentry=ce
    @neuigkeit.save
    
    render 'edit'
  end

  def unpublish
    @neuigkeit = Neuigkeit.find(params[:id])
    @neuigkeit.reverse_publish
    @neuigkeit.save
    if params[:verwalten] 
      redirect_to verwalten_rubrik_path(@neuigkeit.rubrik)
    end
    redirect_to rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit)
  end   
  def publish 
    @neuigkeit = Neuigkeit.find(params[:id])
    @neuigkeit.publish
    @neuigkeit.save
    if params[:verwalten] 
      redirect_to verwalten_rubrik_path(@neuigkeit.rubrik)
    end
    redirect_to  rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit)
  end 
  def publish_to_facebook
    @neuigkeit = Neuigkeit.find(params[:id])
    unless @neuigkeit.picture.url.nil?
      picture_url=URI(root_url)
      picture_url.path=@neuigkeit.picture.url(:locale=>nil, :theme=>nil)
    end
    unless @neuigkeit.published?
      redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit muss veröffentlicht sein um sie auf Facebook zu posten.'
    else
      page=YAML.load_file("#{::Rails.root.to_s}/config/page.yml")
     # page.feed!(:access_token=>page.access_token, :message=>@neuigkeit.text_first_words, :name=>@neuigkeit.title, :link=>rubrik_neuigkeit_url(@neuigkeit.rubrik, @neuigkeit)+".html", :picture=>@neuigkeit.picture.url)
 page.feed!(:access_token=>page.access_token, :message=>@neuigkeit.text_first_words, :name=>@neuigkeit.title, :link=>rubrik_neuigkeit_url(@neuigkeit.rubrik, @neuigkeit)+".html")# , :picture=>picture_url)
     
      redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit auf Facebook gepostet'
    end
  end
  def mail_to_fet
  
  ActionMailer::Base.default_url_options[:host] = request.host_with_port 
  
    @neuigkeit = Neuigkeit.find(params[:id])
    authorize! :publish, @neuigkeit
    unless @neuigkeit.published?
      redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit muss veröffentlicht sein um sie als Mail zu versenden.'
    else      
      NewsMailer.neuigkeit_mail("all@fet.at", params[:id]).deliver
      redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit versendet'
  
    end  
  end
  def mail_preview
    @neuigkeit = Neuigkeit.find(params[:id])
   @user=current_user
    @ability=Ability.new(@user)

    authorize! :publish, @neuigkeit
    render template: "news_mailer/neuigkeit_mail", layout: false
  end
  def newsletter_preview
    authorize! :publish, Neuigkeit
    @neuigkeiten=Neuigkeit.accessible_by(current_ability).where("cache_order<2")
    render template: "news_mailer/daily_newsletter", layout: false
 
 end
  def edit
    @neuigkeit = Neuigkeit.find(params[:id])
    @neuigkeit.no_fallbacks=true
   @rubrik=@neuigkeit.rubrik    
 
    @calentries= @neuigkeit.calentries
    @calentries<<  Calentry.new 

  end
  def find_link
    @rubrik=@neuigkeit.rubrik    
   if can?(:shownonpublic, Rubrik)
      @rubriken = Rubrik.all
    else
      @rubriken = Rubrik.where(:public=>true)
    end   

    @calentries1=@neuigkeit.calentries
    nlink_search = Neuigkeit::LINKTYPES.clone
    nlink_search.collect!{|t| t.constantize}
   # @nlink_search.collect!{|t| t.search(params[:query]).limit(2)}
    @results= Sunspot.search nlink_search do 
      fulltext params[:query]
    end
    
    respond_to do |format|
      format.html { render action:"show" }
      format.js
    end
  
 
  end
  def create_link
    @neuigkeit = Neuigkeit.find(params[:id])

    Nlink.create(:link=>params[:link_type].constantize.find(params[:link_id]),:neuigkeit=>Neuigkeit.find(params[:id]))
    @nlinks=@neuigkeit.nlinks
    respond_to do |format|
      format.html { redirect_to action:"show" }
      format.js
    end
  end
  def delete_link
    @neuigkeit = Neuigkeit.find(params[:id])
    @nlink = @neuigkeit.nlinks.find(params[:nlink_id])
    @nlink.destroy
    respond_to do |format|
      format.html { redirect_to @neuigkeit }
      format.js
    end
  end  
  def create
    @neuigkeit = Neuigkeit.new(params[:neuigkeit])
    @neuigkeit.author=current_user
    
    respond_to do |format|
      if @neuigkeit.save
        format.html { redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end
  
  
  def update
    @neuigkeit = Neuigkeit.find(params[:id])
    respond_to do |format|
      if @neuigkeit.update_attributes(params[:neuigkeit])
        format.html { redirect_to [@neuigkeit.rubrik,@neuigkeit], notice: 'Neuigkeit was successfully updated.' }
      else
        format.html { render action: "edit" }  
      end
    end
  end
  
  # DELETE /neuigkeiten/1
  # DELETE /neuigkeiten/1.json
  def destroy
    @neuigkeit = Neuigkeit.find(params[:id])
    rubrik=@neuigkeit.rubrik
    @neuigkeit.destroy
    respond_to do |format|
      format.html { redirect_to rubrik }
      
    end
   end

private
  def load_toolbar_elements
    @neuigkeit=Neuigkeit.find(params[:id])
    @toolbar_elements=[]
    actions=[]
    actions << {:hicon=>'icon-plus', :text=> I18n.t('neuigkeit.publish'),:path => publish_rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:confirm=> I18n.t('neuigkeit.publish_sure') } if can?(:publish, @neuigkeit) && !@neuigkeit.published?
    actions << {:hicon=>'ffi1-facebook1', :text=> I18n.t('neuigkeit.publishfb'),:path => publish_to_facebook_rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:confirm=>I18n.t('neuigkeit.publishfb_sure') } if can?(:publish, @neuigkeit) && @neuigkeit.published?

actions << {:hicon=>'icon-facebook', :text=> I18n.t('neuigkeit.publishfetmail'),:path => mail_to_fet_rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:confirm=>I18n.t('neuigkeit.publishfetmail_sure') } if can?(:publish, @neuigkeit) && @neuigkeit.published?

    actions << {:hicon=>'icon-minus', :text=> I18n.t('neuigkeit.unpublish'),:path => unpublish_rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:confirm=> I18n.t('neuigkeit.unpublish_sure') } if can?(:unpublish, @neuigkeit) && @neuigkeit.published?
  


    @toolbar_elements << {:text=>I18n.t('common.edit'),:path=>edit_rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:icon=>:pencil} if can? :edit, @neuigkeit.rubrik
if  can?(:showversions, Neuigkeit)
    @versions= @neuigkeit.translation.versions.select([:created_at]).reverse

    @toolbar_elements <<{:path=>rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit),:method=>:versions,:versions=>@versions}
end     
actions << {:hicon=>'icon-remove-circle', :text=> I18n.t('common.delete'),:path => rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit), :method=> :delete,:confirm=>'Sure?' } if can? :delete, @neuigkeit
    @toolbar_elements << {:text => "action", :method => :dropdown, :elements=> actions} unless actions.empty?
  end
  

  def load_toolbar_elements_edit
    @neuigkeit = Neuigkeit.find(params[:id])
    @toolbar_elements=[]
    @toolbar_elements << {:text=>I18n.t('common.show'),:path=>rubrik_neuigkeit_path(@neuigkeit.rubrik,@neuigkeit)} if can? :show, @neuigkeit
    
  end

 
end
