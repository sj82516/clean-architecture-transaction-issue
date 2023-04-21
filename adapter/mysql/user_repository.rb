require_relative './repository'
require_relative '../../domain/user'

class UserRepository < Repository
  TABLE_NAME = "users"

  def create(user)
    client.prepare("INSERT INTO #{TABLE_NAME} (id, points) VALUES (?, ?)")
          .execute(user.id, user.points)
  end

  def find_by_id(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ?")
                   .execute(id)
                   .first
    User.new(result['id'], result['points'])
  end

  def lock(id)
    result = client.prepare("SELECT * FROM #{TABLE_NAME} WHERE id = ? FOR UPDATE")
                   .execute(id)
                   .first
    User.new(result['id'], result['points'])
  end

  def save(user)
    client.prepare("UPDATE #{TABLE_NAME} SET points = ? WHERE id = ?")
          .execute(user.points, user.id)
  end
end
