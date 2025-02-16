class Api::ContactsController < ApplicationController
    before_action :authenticate_user!  # 認証が必要
    before_action :admin_only, only: [:index]  # admin のみ index 許可

    def index
    contacts = Contact.all
    render json: contacts
    end

    def create
    contact = Contact.new(contact_params)
    if contact.save
        render json: { message: "お問い合わせが送信されました！" }, status: :created
    else
        render json: { errors: contact.errors.full_messages }, status: :unprocessable_entity
    end
    end

    private

    def contact_params
    params.require(:contact).permit(:name, :email, :message)
    end

    def admin_only
    unless current_user&.admin?
        render json: { error: "権限がありません" }, status: :forbidden
    end
    end
end
