json.array! @posts do |post|
  json.id post.id
  json.title post.title
  json.date post.date
  json.url post_url(post)
end
