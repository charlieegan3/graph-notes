class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  def index
    @notes = Note.roots.order(created_at: :asc)
  end

  def search
    terms = params[:query].downcase.split(/\W+/)
    @notes = [
      Note.tagged_with(terms, any: true),
      Note.where("title like ?", "%#{params[:query]}%"),
      Note.where("comment like ?", "%#{params[:query]}%"),
      Note.where("link like ?", "%#{params[:query]}%")
    ].flatten.uniq
  end

  # GET /notes/1
  def show
    redirect_to notes_path + "#note-#{@note.id}"
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to @note, notice: 'Note was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_url, notice: 'Note was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:title, :link, :comment, :parent_id, :tag_list)
    end
end
