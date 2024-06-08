const cloudinary = require('cloudinary').v2;
          
cloudinary.config({ 
  cloud_name: 'dskt7yadi', 
  api_key: 121985378969911, 
  api_secret: 'QQdT0f2eWv1t9vVNgssH3mR233Q' 
});

module.exports = cloudinary;