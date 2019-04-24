json.extract! room, :id, :name
json.channel_name [RoomChannel.channel_name, room.to_gid_param].join(':')