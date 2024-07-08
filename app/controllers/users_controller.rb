class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :user_already_exist, only: %i[new create]

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user == current_account.user
      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to @user, alert: "You are not the owner of this account."
    end
  end

  # DELETE /users/1
  def destroy
    if @user == current_account.user
      @user.account.destroy!
      redirect_to new_account_session_path, notice: "User was successfully destroyed."
    else
      redirect_to @user, alert: "You are not the owner of this account."
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_already_exist
    unless current_account.user.nil?
      redirect_to root_path, alert: "Your profile already exists for your account."
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :nickname, :bio).merge(account_id: current_account.id)
  end
end
