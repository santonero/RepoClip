pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers", preload: false
pin "vjs"
pin "video.js", to: "https://unpkg.com/video.js@8.10.0/dist/video.min.js"
pin "emoji-mart", to: "https://unpkg.com/emoji-mart@5.5.2/dist/browser.js"
