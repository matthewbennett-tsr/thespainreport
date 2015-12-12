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
  
  def search_entries
    if params[:search]
      @entries = Entry.search(params[:search]).order("created_at DESC")
    else
      @entries = Entry.indexlimit.order('created_at DESC')
    end
  end
  
  def index
    feed_teasers
    entry_count
    feed_count
    if params[:search]
      @entries = Entry.search(params[:search]).order("created_at DESC")
    else
      @entries = Entry.indexlimit.order('created_at DESC')
    end
  end
  
  def world_all
    @entries = Entry.joins(:feed).merge(Feed.world_all)
    feed_teasers
  end
  
  def world_home
    @entries = Entry.joins(:feed).merge(Feed.world_home)
    feed_teasers
  end
  
  def world_politics
    @entries = Entry.joins(:feed).merge(Feed.world_politics)
    feed_teasers
  end
  
  def world_economy
    @entries = Entry.joins(:feed).merge(Feed.world_economy)
    feed_teasers
  end
  
  def world_foreign_affairs
    @entries = Entry.joins(:feed).merge(Feed.world_foreign_affairs)
    feed_teasers
  end
  
  def world_media
    @entries = Entry.joins(:feed).merge(Feed.world_media)
    feed_teasers
  end
  
  def spain_english
    @entries = Entry.joins(:feed).merge(Feed.spain_english)
    feed_teasers
  end
  
  def spain_all
    @entries = Entry.joins(:feed).merge(Feed.spain_all)
    feed_teasers
  end
  
  def spain_home
    @entries = Entry.joins(:feed).merge(Feed.spain_home)
    feed_teasers
  end
  
  def spain_opinion
    @entries = Entry.joins(:feed).merge(Feed.spain_opinion)
    feed_teasers
  end
  
  def spain_international
    @entries = Entry.joins(:feed).merge(Feed.spain_international)
    feed_teasers
  end
  
  def spain_national
    @entries = Entry.joins(:feed).merge(Feed.spain_national)
    feed_teasers
  end
  
  def spain_economy
    @entries = Entry.joins(:feed).merge(Feed.spain_economy)
    feed_teasers
  end
  
  def spain_other
    @entries = Entry.joins(:feed).merge(Feed.spain_other)
    feed_teasers
  end
  
  def cincodias
    @entries = Entry.cincodias.indexlimit
    feed_teasers
  end
  
  def abc
    @entries = Entry.abc.indexlimit
    feed_teasers
  end
  
  def antenatres
    @entries = Entry.antenatres.indexlimit
    feed_teasers
  end
  
  def cope
    @entries = Entry.cope.indexlimit
    feed_teasers
  end
  
  def efe
    @entries = Entry.efe.indexlimit
    feed_teasers
  end
  
  def elconfidencial
    @entries = Entry.elconfidencial.indexlimit
    feed_teasers
  end
  
  def elconfidencialdigital
    @entries = Entry.elconfidencialdigital.indexlimit
    feed_teasers
  end
  
  def eldiario
    @entries = Entry.eldiario.indexlimit
    feed_teasers
  end
  
  def eleconomista
    @entries = Entry.eleconomista.indexlimit
    feed_teasers
  end
  
  def elespanol
    @entries = Entry.elespanol.indexlimit
    feed_teasers
  end
  
  def elmundo
   @entries = Entry.elmundo.indexlimit
   feed_teasers
  end
  
  def elpais
    @entries = Entry.elpais.indexlimit
    feed_teasers
  end
  
  def libertaddigital
    @entries = Entry.libertaddigital.indexlimit
    feed_teasers
  end
  
  def elperiodico
    @entries = Entry.elperiodico.indexlimit
    feed_teasers
  end
  
  def europapress
    @entries = Entry.europapress.indexlimit
    feed_teasers
  end
  
  def expansion
    @entries = Entry.expansion.indexlimit
    feed_teasers
  end
  
  def infolibre
    @entries = Entry.infolibre.indexlimit
    feed_teasers
  end
  
  def lasexta
    @entries = Entry.lasexta.indexlimit
    feed_teasers
  end
  
  def larazon
    @entries = Entry.larazon.indexlimit
    feed_teasers
  end
  
  def lavanguardia
    @entries = Entry.lavanguardia.indexlimit
    feed_teasers
  end
  
  def libertaddigital
    @entries = Entry.libertaddigital.indexlimit
    feed_teasers
  end
  
  def ondacero
    @entries = Entry.ondacero.indexlimit
    feed_teasers
  end
  
  def publico
    @entries = Entry.publico.indexlimit
    feed_teasers
  end
  
  def ser
    @entries = Entry.ser.indexlimit
    feed_teasers
  end
  
  def telecinco
    @entries = Entry.telecinco.indexlimit
    feed_teasers
  end
  
  def tve
    @entries = Entry.tve.indexlimit
    feed_teasers
  end
  
  def vozpopuli
    @entries = Entry.vozpopuli.indexlimit
    feed_teasers
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
      params.require(:entry).permit(:feed_id, :atom_id, :title, :url, :content)
    end
end