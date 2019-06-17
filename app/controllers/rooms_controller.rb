class RoomsController < BaseController
  before_action :fetch_rooms, except: %i[create update]

  def index; end

  def new
    @room = Room.new
  end
  
  def show
    @room = Room.find(params[:id])
    @room_message = RoomMessage.new(room: @room)
  end

  def create
    @room = current_user.rooms.build room_params

    if @room.save
      flash[:success] = "Room #{@room.name} was created successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  def edit
    @room = current_user.rooms.find(params[:id]) 
  end

  def update
    @room = current_user.rooms.find(params[:id])

    if @room.update(room_params)
      flash[:success] = "Room #{@room.name} was updated successfully"
      redirect_to rooms_path
    else
      render :new
    end
  end

  private

  def fetch_rooms
    @rooms = Room.order(name: :asc)
  end

  def room_params
    params.require(:room).permit(:name)
  end
end