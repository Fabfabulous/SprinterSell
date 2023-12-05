class NotesController < ApplicationController
  def create
    @note = Note.new(note_params)
    if @note.save
      @notice = "Note bien ajoutée"
    else
      @notice = "Note pas ajoutée"
    end
    redirect_to root_path
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :company_id, photos: [])
  end
end
