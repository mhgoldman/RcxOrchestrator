class CommandSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :path, :args
end
