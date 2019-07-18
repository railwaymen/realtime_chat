# frozen_string_literal: true

class AttachmentsController < BaseController
  def create
    attachment = current_user.attachments.build(attachment_params)

    if attachment.save
      render json: attachment.serialized, status: 200
    else
      render json: Api::V1::ErrorSerializer.render_as_hash(attachment), status: 422
    end
  end

  def destroy
    attachment = Attachment.find(params[:id])
    authorize attachment

    attachment.destroy!
    head :no_content
  end

  private

  def attachment_params
    params.permit(:file)
  end
end
