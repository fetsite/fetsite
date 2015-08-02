# -*- coding: utf-8 -*-
class Ability
  include CanCan::Ability
  def initialize(user,request=nil,key=nil)
    loggedin=!(user.nil?)
    unless key.nil?
      k=Key.find_by_uuid(key)
      if !k.nil? && k.is_valid && k.typ == 0
        user=k.user
      end
    end
    user ||=  User.new # guest user (not logged in)

    can :manage, Survey::Question 
    can :manage, Survey::Choice
    can :manage, Survey::Answer

    #---------------------------------------------------
    
    can [:index,:hide], Comment
    can :show, Comment
    
    if loggedin
      can [:create,:new], Comment
      can [:comment], Comment
    end

  #  can :manage, Comment
    unless user.has_role?("fetadmin")
      cannot :delete, Comment
cannot :destroy, Comment
    end
    #-----------------------------------------------------
    # Rechteverwaltung fuer Studien Modul
    can [:show, :index], Studium, :visible=>true
    can [:show], Modulgruppe
    can [:show, :index], Modul
    can [:show, :index, :beispiel_sammlung], Lva
    can [:create, :show], Beispiel
    if loggedin
      can :like, Beispiel
      can :dislike, Beispiel    
    end
    if (user.has_role?("moderator",Beispiel))
      can :flag, Beispiel
      can [:edit, :update], Beispiel
    end
    if (user.has_role?("moderator",Lva))
      can [:verwalten, :edit, :compare_tiss, :load_tiss, :update], Lva
    end
    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can :manage, Modulgruppe
      can :manage, Modul
      can :manage, Lva
      can :manage, Studium
      can :manage, Beispiel
      can :manage, Lecturer
      
    end
    unless user.has_role?("fetadmin")
      cannot :delete, Studium    
      cannot :delete, Modulgruppe
      cannot :delete, Modul
  
    end
    if user.has_role?("fetadmin")
    can [:index, :parse, :show], Crawlobject
end
    #-----------------------------------------------------
    # Rechteverwaltung fuer Informationen
    can [:show, :index,:faqs], Themengruppe, :public=>true  
    can [:show], Thema, :isdraft=>false,  :themengruppe=>{:public=>true}
    can :show, Frage
    if loggedin
    end
    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can :manage, Frage
      can :showdraft , Thema
      can :showintern, Thema
      can :manage, Thema
      can [:index, :faqs, :show,:new,:edit, :verwalten_all, :verwalten, :sort_themengruppen, :sort_themen, :create, :update ], Themengruppe
      can :manage, Attachment
    end
    can [:update,:edit,:verwalten, :showdraft], Thema, :id=>Thema.with_role(:editor, user).pluck(:id)
    can [:index, :faqs, :show,:new,:edit, :verwalten_all, :verwalten, :sort_themengruppen, :sort_themen, :create, :update, :delete], Thema, :themengruppe_id=>Themengruppe.with_role(:admin,user).pluck(:id)
    can :delete, Themengruppe, :id=>Themengruppe.with_role(:admin,user).pluck(:id)
    if user.has_role?("fetadmin")
      can :delete, Themengruppe
      can :delete, Thema
    end

    unless user.has_role?("fetadmin")
      cannot :delete, Themengruppe
      cannot :delete, Thema
    end

    #-----------------------------------------------------
    # Rechteverwaltung fuer Fotos

#    can [:show,:index], Gallery, :intern=>false
      can [:show,:index], Gallery
      can :show, Foto

    if loggedin
    end
    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can :manage, Gallery
      can :manage, Foto
    end
    unless user.has_role?("fetadmin")
      cannot :delete, Gallery
    end
    
    #-----------------------------------------------------
    # Rechteverwaltung fuer Mitarbeiter
    can [:show, :index], Fetprofile
    can [:show, :index],Gremium
    if loggedin
    end
    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can :manage, Fetprofile
      can :manage, Gremium
      can :manage, Membership
    end
    unless user.has_role?("fetadmin")
      cannot :delete, Fetprofile
      cannot :delete ,Gremium
    end
    
    #-----------------------------------------------------
    # Rechteverwaltung fuer Neuigkeiten
    can :index, Rubrik
    can [:show], Rubrik, :public=>true
    can [:list], Neuigkeit, :cache_is_published=>true,  :rubrik=>{:public=>true}
    can :show, Neuigkeit, :cache_is_published=>true, :rubrik=>{:public=>true}

    if loggedin
    end
    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))

      can :showversions, Neuigkeit
      can :showintern, Neuigkeit
      can :showintern, Rubrik
      can :seeintern, User
      can :list, Neuigkeit
      can :shownonpublic, Rubrik
      can :manage, Nlink
    end
    if user.has_role?("newsadmin") || user.has_role?("fetadmin") 
      can :addmoderator, Rubrik
    end    
    if user.has_role?("fetadmin")
      can :addfetuser, User
      can :addfetadmin, User
      can :edit, User
      can :manage, User
    end
    
    if user.has_role?("newsadmin") || user.has_role?( "fetadmin") || user.has_role?( "fetuser") 
      can :manage, Rubrik
      can :manage, Neuigkeit
      can :showunpublished, Neuigkeit
    end
    unless user.has_role?("fetadmin")
      cannot :delete, Rubrik
      cannot :delete, Neuigkeit
    end
    # Calendar

    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can [:show, :edit, :update,:new,:create,:write, :write_etherpad, :read_from_etherpad, :dump_to_etherpad, :search], Document
      can :manage, Meeting
      can :manage, Meetingtyp
    end    
    if user.has_role?("fetadmin")
      can :manage, Document
    end
    if loggedin
    end
    can :show, Document, :typ=>11
    unless user.has_role?( "fetadmin")
      cannot :delete, Document
      cannot :delete, Meeting
    end
    if user.has_role?( "fetadmin")
      can :manage, Meetingtyp
      
    end
    
    # Rechteverwaltung Kalender 
    can [:show, :index], Calendar, :public => true 
    can [:showics], Calendar
    # can [:show], Calentry
    if  (!k.nil? && k.typ==1 && (k.user.has_role?("fetuser")||k.user.has_role?("fetadmin")))  
      if k.parent.nil?
        can [:show,:index], Calendar
      else
        can [:show], Calendar, id: k.parent_id
      end 
    end

    if( user.has_role?("fetuser") || user.has_role?("fetadmin"))
      can [:show,:index], Calendar
      can  [:edit, :update,:new,:create,:verwalten], Calendar
      can  [:edit, :update,:new,:create,:verwalten,:delete], Calentry
    end
    if( user.has_role?("fetadmin"))
      can [:delete],Calendar
      can [:delete],Calentry
      can :doadmin, User
    end

    unless user.has_role?("fetadmin")
    end
    
  end
end
