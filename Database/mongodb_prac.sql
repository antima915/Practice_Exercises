-- Create a Database
use EduTech

-- Insert more than one documents in the collection
db.Courses.insertMany(
      [
        {
          admin : 'Tom',
          sessions : 'jan-march',
          assignments : 'shell-script' 
        },
        {
          admin : 'Lucas',
          sessions : 'nov-jan',
          assignments :'postgresql' 
        },
        {
          admin : 'Harry',
          sessions : 'may-august',
          assignments : 'mongodb' 
        }
    ]
)

-- Update a single document at a time
db.Courses.update(
        { admin : 'Harry' },
        { $set :{ sessions : 'nov-dec' } }
)

-- Update more than one documents at a time
db.Courses.updateMany(
        { assignments : 'mongodb' },
        { $set :{ sessions : 'mar-apr' } }
)
        
db.Courses.updateMany(
        { admin : { $in: ['Lucas','Harry']} },
        { $set :{ sessions : 'may-aug' } }
)

-- Delete more than one documents at a time     
db.Courses.deleteMany(
        { assignments : 'postgresql' }
)