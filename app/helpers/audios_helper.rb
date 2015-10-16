module AudiosHelper
  VM_ADD = "http://dharmendrav.housing.com:4000"
  # VM_ADD = "http://neeraja.housing.com:4000"
  
  def add_url posts, audios
    count = 0
    posts.each do |post|
      post[:audio_url] = VM_ADD + audios[count].audio.url
      count+=1
    end
    posts
  end
  
end
