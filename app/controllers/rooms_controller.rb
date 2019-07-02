# frozen_string_literal: true

class RoomsController < BaseController
  include RoomsConcern
  before_action :fetch_rooms, except: :show

  def index; end

  def new
    @room = Room.new
  end

  def show
    @room = Room.kept.find(params[:id])
    messages = @room.messages.includes(:user).order(id: :asc)

    @chat_data = ChatComponent.render(@room, messages: messages, current_user: current_user)

    current_user.update_room_activity(@room)
    fetch_rooms
  end

  def create
    @room = current_user.rooms.build(create_room_params)

    if @room.save
      AppChannel.broadcast_to('app', data: @room.serialized, type: :room_create)
      create_rooms_user_for_owner!(@room) if @room.public == false

      flash[:success] = "Room #{@room.name} has been created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
    @room = Room.kept.find(params[:id])
    authorize @room
  end

  def update
    @room = Room.kept.find(params[:id])
    authorize @room

    if @room.update(update_room_params)
      AppChannel.broadcast_to('app', data: @room.serialized, type: :room_update)

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

    AppChannel.broadcast_to('app', data: @room.serialized, type: :room_destroy)
    RoomChannel.broadcast_to(@room, type: :room_close)

    redirect_to rooms_path, notice: "Room #{@room.name} has been closed successfully"
  end

  private

  def fetch_rooms
    rooms = policy_scope(Room).kept.order(name: :asc)
    @rooms_list_data = RoomsListComponent.render(current_user, rooms: rooms)
  end

  def create_room_params
    params.require(:room).permit(:name, :public)
  end

  def update_room_params
    params.require(:room).permit(:name)
  end
end
