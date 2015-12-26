class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]

  # GET /entries
  # GET /entries.json
  def feed_teasers
    @teaser_world_entries = Entry.world_all.teaser_limit
    @teaser_spain_entries = Entry.spain_all.teaser_limit
  end
  
  def entry_count
    @entry_count = Entry.count
  end
  
  def feed_count
    @feed_count = Feed.count
  end
  
  def feedsearches
    @stories = Story.all.order( 'stories.updated_at DESC' )
    @categories = Category.all.order( 'categories.category ASC' )
    @regions = Region.all.order( 'regions.region ASC' )
  end
  
  def index
    feed_teasers
    entry_count
    feed_count
    if params[:search] && params[:all] == '1'
      @entries = Entry.search(params[:search]).searchlimit.order("created_at DESC")
      feedsearches
    elsif params[:search] && params[:any] == '1'
      terms = params[:search].scan(/"[^"]*"|'[^']*'|[^"'\s]+/)
      query = terms.map { |term| "title @@ '%#{term}%'" }.join(" OR ")
      @entries = Entry.where(query).searchlimit.order("created_at DESC")
      feedsearches
    elsif params[:search]
      @entries = Entry.search(params[:search]).searchlimit.order("created_at DESC")
      feedsearches
    else
      @entries = Entry.indexlimit.order('created_at DESC')
      feedsearches
    end
  end
  
  def world_all
    @entries = Entry.joins(:feed).merge(Feed.world_all).indexlimit
    feed_teasers
    feedsearches
  end
  
  def world_home
    @entries = Entry.joins(:feed).merge(Feed.world_home).indexlimit
    feed_teasers
    feedsearches
  end
  
  def world_politics
    @entries = Entry.joins(:feed).merge(Feed.world_politics).indexlimit
    feed_teasers
    feedsearches
  end
  
  def world_economy
    @entries = Entry.joins(:feed).merge(Feed.world_economy).indexlimit
    feed_teasers
    feedsearches
  end
  
  def world_foreign_affairs
    @entries = Entry.joins(:feed).merge(Feed.world_foreign_affairs).indexlimit
    feed_teasers
    feedsearches
  end
  
  def world_media
    @entries = Entry.joins(:feed).merge(Feed.world_media).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_english
    @entries = Entry.joins(:feed).merge(Feed.spain_english).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_all
    @entries = Entry.joins(:feed).merge(Feed.spain_all).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_home
    @entries = Entry.joins(:feed).merge(Feed.spain_home).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_opinion
    @entries = Entry.joins(:feed).merge(Feed.spain_opinion).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_international
    @entries = Entry.joins(:feed).merge(Feed.spain_international).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_national
    @entries = Entry.joins(:feed).merge(Feed.spain_national).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_economy
    @entries = Entry.joins(:feed).merge(Feed.spain_economy).indexlimit
    feed_teasers
    feedsearches
  end
  
  def spain_other
    @entries = Entry.joins(:feed).merge(Feed.spain_other).indexlimit
    feed_teasers
    feedsearches
  end
  
  def cincodias
    @entries = Entry.cincodias.indexlimit
    feed_teasers
    feedsearches
  end
  
  def abc
    @entries = Entry.abc.indexlimit
    feed_teasers
    feedsearches
  end
  
  def antenatres
    @entries = Entry.antenatres.indexlimit
    feed_teasers
    feedsearches
  end
  
  def cope
    @entries = Entry.cope.indexlimit
    feed_teasers
    feedsearches
  end
  
  def efe
    @entries = Entry.efe.indexlimit
    feed_teasers
    feedsearches
  end
  
  def elconfidencial
    @entries = Entry.elconfidencial.indexlimit
    feed_teasers
    feedsearches
  end
  
  def elconfidencialdigital
    @entries = Entry.elconfidencialdigital.indexlimit
    feed_teasers
    feedsearches
  end
  
  def eldiario
    @entries = Entry.eldiario.indexlimit
    feed_teasers
    feedsearches
  end
  
  def eleconomista
    @entries = Entry.eleconomista.indexlimit
    feed_teasers
    feedsearches
  end
  
  def elespanol
    @entries = Entry.elespanol.indexlimit
    feed_teasers
    feedsearches
  end
  
  def elmundo
   @entries = Entry.elmundo.indexlimit
   feed_teasers
   feedsearches
  end
  
  def elpais
    @entries = Entry.elpais.indexlimit
    feed_teasers
    feedsearches
  end
  
  def libertaddigital
    @entries = Entry.libertaddigital.indexlimit
    feed_teasers
    feedsearches
  end
  
  def elperiodico
    @entries = Entry.elperiodico.indexlimit
    feed_teasers
    feedsearches
  end
  
  def europapress
    @entries = Entry.europapress.indexlimit
    feed_teasers
    feedsearches
  end
  
  def expansion
    @entries = Entry.expansion.indexlimit
    feed_teasers
    feedsearches
  end
  
  def infolibre
    @entries = Entry.infolibre.indexlimit
    feed_teasers
    feedsearches
  end
  
  def lasexta
    @entries = Entry.lasexta.indexlimit
    feed_teasers
    feedsearches
  end
  
  def larazon
    @entries = Entry.larazon.indexlimit
    feed_teasers
    feedsearches
  end
  
  def lavanguardia
    @entries = Entry.lavanguardia.indexlimit
    feed_teasers
    feedsearches
  end
  
  def libertaddigital
    @entries = Entry.libertaddigital.indexlimit
    feed_teasers
    feedsearches
  end
  
  def ondacero
    @entries = Entry.ondacero.indexlimit
    feed_teasers
    feedsearches
  end
  
  def publico
    @entries = Entry.publico.indexlimit
    feed_teasers
    feedsearches
  end
  
  def ser
    @entries = Entry.ser.indexlimit
    feed_teasers
    feedsearches
  end
  
  def telecinco
    @entries = Entry.telecinco.indexlimit
    feed_teasers
    feedsearches
  end
  
  def tve
    @entries = Entry.tve.indexlimit
    feed_teasers
    feedsearches
  end
  
  def vozpopuli
    @entries = Entry.vozpopuli.indexlimit
    feed_teasers
    feedsearches
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end
  
  # GET /entries/new
  def new
    redirect_to root_url
    flash[:success] = "Now then, now then, you're not allowed to do that."
  end

  # GET /entries/1/edit
  def edit
    redirect_to root_url
    flash[:success] = "Now then, now then, you're not allowed to do that."
  end

  # POST /entries
  # POST /entries.json
  def create
    @entry = Entry.new(entry_params)

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1
  # PATCH/PUT /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:feed_id, :atom_id, :title, :url)
    end
end