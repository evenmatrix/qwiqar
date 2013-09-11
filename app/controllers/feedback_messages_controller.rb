class FeedbackMessagesController < ApplicationController
  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = FeedbackMessage.new(params[:feedback])

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: 'Feedback was successfully created.' }
        format.json { render json: @feedback }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end
end
