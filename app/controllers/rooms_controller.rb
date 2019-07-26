# frozen_string_literal: true

class RoomsController < BaseController
  include RoomsConcern

  before_action :fetch_rooms
  before_action :fetch_users, only: %i[new create edit update]

  def index; end

  def more
    current_user_rooms = current_user.rooms_users.pluck(:room_id)
    @rooms = Room.kept.open.where.not(id: current_user_rooms)
  end

  def join
    room = Room.kept.open.find(params[:id])

    RoomsUser.create!(user: current_user, room: room)
    UserChannel.broadcast_to(current_user, data: room.serialized, type: :room_create)

    head :ok
  end

  def show
    @room = Room.kept.find(params[:id])
    authorize @room

    messages = @room.messages.includes(:user, :attachments).order(id: :desc).limit(20).reverse
    @chat_data = ChatComponent.render(@room, messages: messages, current_user: current_user)

    current_user.update_room_activity(@room)
    fetch_rooms
  end

  def new
    @room = Room.new(type: params[:type])
    @selected_users = ''
  end

  def create
    @selected_users = params.fetch(:users_ids, '')

    @room = Rooms::Creator.new(
      room_params: create_room_params,
      user_ids: @selected_users,
      user: current_user
    ).call

    if @room.valid?
      flash[:success] = "Room #{@room.name} has been created successfully"
      redirect_to room_path(@room)
    else
      render :new
    end
  end

  def edit
    @room = Room.kept.find(params[:id])
    authorize @room

    @selected_users = @room.users.pluck(:id).join(',')
  end

  def update
    @room = Room.kept.find(params[:id])
    authorize @room

    @selected_users = params.fetch(:users_ids, '')

    Rooms::Updater.new(
      room_params: update_room_params,
      user_ids: @selected_users,
      user: current_user,
      room: @room
    ).call

    if @room.valid?
      flash[:success] = "Room #{@room.name} has been updated successfully"
      redirect_to rooms_path
    else
      render :edit
    end
  end

  def destroy
    @room = Room.kept.find(params[:id])
    authorize @room

    @room.discard
    AppChannel.broadcast_to('app', data: @room.serialized, type: :room_close)

    redirect_to rooms_path, notice: "Room #{@room.name} has been closed successfully"
  end

  private

  def fetch_rooms
    rooms = policy_scope(Room).includes(:users).kept.order(:type, name: :asc)
    @rooms_list_data = RoomsListComponent.render(current_user, rooms: rooms)
  end

  def fetch_users
    @users_data = UsersSelectComponent.render(User.where.not(id: current_user.id))
  end

  def create_room_params
    params.require(:room).permit(:name, :description, :type)
  end

  def update_room_params
    params.require(:room).permit(:name, :description)
  end
end
