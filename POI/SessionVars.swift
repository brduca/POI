import Foundation

struct SessionVars {
   
    static var detailId: String? = nil
}


class ManagePreferences {
    
    static internal let favorites = "favorites"
    static internal let visited = "visited"
    
    static internal let defaults = NSUserDefaults.standardUserDefaults()
    
    class func isFavorite(id: String) -> Bool {

        if let favoritesArray = defaults.arrayForKey(self.favorites) as? [String] {
        
            return contains(favoritesArray, id)
        }
        
        return false
    }
    
    class func addToFavorite(id: String) {
        
        if  var favoritesArray = defaults.arrayForKey(self.favorites) as? [String] {
        
            if let index = find(favoritesArray, id)
            {
                return
            }
            
            favoritesArray.append(id)
            defaults.setObject(favoritesArray, forKey: self.favorites)
            return
        }
        
        defaults.setObject([id], forKey: self.favorites)
    }
  
    
    class func removeFromFavorite(id: String) {
        
        if  var favoritesArray = defaults.arrayForKey(self.favorites) as? [String] {
            
            if let index = find(favoritesArray, id)
            {
                favoritesArray.removeAtIndex(index)
                defaults.setObject(favoritesArray, forKey: self.favorites)
            }
        }
    }
    
    class func isVisited(id: String) -> Bool {
        
        if  var visitedArray = defaults.arrayForKey(self.visited) as? [String] {
            
            return contains(visitedArray, id)
        }
        
        return false
    }
    
    class func addToVisited(id: String)  {
    
        if var visitedArray = defaults.arrayForKey(self.visited) as? [String] {
            
            if let index = find(visitedArray, id)
            {
                return
            }
            
            visitedArray.append(id)
            defaults.setObject(visitedArray, forKey: self.visited)
            return
        }
        
        defaults.setObject([id], forKey: self.visited)
    }
    
    class func removeFromVisited(id: String)  {
        
        if var visitedArray = defaults.arrayForKey(self.visited) as? [String] {
            
            if let index = find(visitedArray, id)
            {
                visitedArray.removeAtIndex(index)
                defaults.setObject(visitedArray, forKey: self.visited)
            }
        }
    }
}