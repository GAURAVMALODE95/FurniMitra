
Map<String, List<String>> sectionCategoryMap = {
  "New from Us": ["new"],
  "Beds and Mattresses": ["beds", "matress", "bed tabels"],
  "Furniture": ["furniture_sets", "sofas", "tabels"],
  "Decoration": ["frames", "mirrors", "plants"],
  "Home Improvement": [ "smart lights","knobs", "bathroom lights",],
  "Kitchen": [ "cutlery", "dinner", "kitchen electronics"],
  "Lighting": ["lamps", "smart lights", "outdoor lights"],
  "Baby and Children": ["children", "kids"],
  "Sale": ["sale"],
};

// Defining mappings for related list categories
Map<String, List<String>> listCategoryMap = {
  "New from Us": ["sale", "furniture_sets", "outdoor"],
  "Beds and Mattresses": ["textiles", "bed tabels", "frames"],
  "Furniture": ["gaming", "sofas", "bookcases"],
  "Decoration": ["mirrors", "plants", "textiles"],
  "Home Improvement": ["bathroom lights", "knobs", "smart lights"],
  "Kitchen": ["bowls", "cutlery", "kitchen storage"],
  "Lighting": ["bathroom lights", "outdoor lights", "smart lights"],
  "Baby and Children": ["children", "kids", "furniture_sets"],
  "Sale": ["furniture_sets", "gaming", "sofas"],
};


//this is causing database locked for 10 seconds because of performing too many queries