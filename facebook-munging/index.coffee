fs = require 'fs'

posts = require './input.json'

mungedPosts = []

for p in posts
  comments = []

  unless p.comments?
    p.comments = {}
    p.comments.data = []

  p.comments.data.unshift {
    from:
      name: p.from.name
    created_time: p.created_time
    message: p.message
  }

  for comment in p.comments.data
    #regex = regexToken = /(((ftp|https?):\/\/)[\-\w@:%_\+.~#?,&\/\/=]+)|((mailto:)?[_.\w-]+@([\w][\w\-]+\.)+[a-zA-Z]{2,3})/g
    regex = regexToken = /(?:(?:ht|f)tp(?:s?)\:\/\/|~\/|\/)?(?:\w+:\w+@)?((?:(?:[-\w\d{1-3}]+\.)+(?:com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|edu|co\.uk|ac\.uk|it|fr|tv|museum|asia|local|travel|[a-z]{2}))|((\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)(\.(\b25[0-5]\b|\b[2][0-4][0-9]\b|\b[0-1]?[0-9]?[0-9]\b)){3}))(?::[\d]{1,5})?(?:(?:(?:\/(?:[-\w~!$+|.,=]|%[a-f\d]{2})+)+|\/)+|\?|#)?(?:(?:\?(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)(?:&(?:[-\w~!$+|.,*:]|%[a-f\d{2}])+=?(?:[-\w~!$+|.,*:=]|%[a-f\d]{2})*)*)*(?:#(?:[-\w~!$ |\/.,*:;=]|%[a-f\d]{2})*)?/g
    if comment.message?
      #console.log comment.message.match(regex)
      articles = comment.message.match(regex)?.map (url) -> {url: url}
    comments.push {
      author: comment.from.name
      created_at: comment.created_time
      body: comment.message
      articles: articles
    }

  mungedPosts.push {
    author: p.from.name
    created_at: p.created_time
    comments: comments
  }

fs.writeFileSync 'output.json', JSON.stringify mungedPosts, null, 4
