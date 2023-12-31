class NotesController < ApplicationController
  def new
    note = params[:note]
    company = Company.find(params[:company_id])
    rephrased_note = chatgpt(note, company)
    render plain: rephrased_note || ""
  end

  def create
    @note = Note.new(note_params)
    if @note.save
      @notice = "Note created"
    else
      @notice = "Error creating the note"
    end
    redirect_to root_path, notice: @notice
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :company_id, photos: [])
  end

  def chatgpt(note, company)
    client = OpenAI::Client.new
    chaptgpt_response = client.chat(parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: "I'm a business seller from a company called Skool, we sel e-learning solution to schools. Can you rephrase the note of my last meeting, here are the main points: #{note}"}]
    })
    chaptgpt_response.dig("choices", 0, "message", "content")
  end
end
