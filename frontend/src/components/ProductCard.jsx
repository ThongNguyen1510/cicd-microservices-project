import { Edit2, Trash2, Package } from 'lucide-react'

function ProductCard({ product, onEdit, onDelete }) {
  const formatPrice = (price) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(price)
  }

  const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    })
  }

  return (
    <div className="card hover:shadow-lg transition-shadow duration-200">
      <div className="flex items-start justify-between mb-4">
        <div className="flex items-center space-x-3">
          <div className="p-2 bg-primary-100 rounded-lg">
            <Package className="w-6 h-6 text-primary-600" />
          </div>
          <div>
            <h3 className="text-lg font-semibold text-gray-900">{product.name}</h3>
            {product.category && (
              <span className="inline-block px-2 py-1 text-xs font-medium text-primary-700 bg-primary-50 rounded-full mt-1">
                {product.category}
              </span>
            )}
          </div>
        </div>
      </div>

      <p className="text-gray-600 text-sm mb-4 line-clamp-2">
        {product.description || 'No description available'}
      </p>

      <div className="space-y-2 mb-4">
        <div className="flex justify-between items-center">
          <span className="text-sm text-gray-500">Price:</span>
          <span className="text-lg font-bold text-gray-900">{formatPrice(product.price)}</span>
        </div>
        <div className="flex justify-between items-center">
          <span className="text-sm text-gray-500">Stock:</span>
          <span className={`text-sm font-medium ${
            product.stockQuantity > 50 ? 'text-green-600' : 
            product.stockQuantity > 10 ? 'text-yellow-600' : 
            'text-red-600'
          }`}>
            {product.stockQuantity} units
          </span>
        </div>
        <div className="flex justify-between items-center pt-2 border-t border-gray-100">
          <span className="text-xs text-gray-400">Added:</span>
          <span className="text-xs text-gray-500">{formatDate(product.createdAt)}</span>
        </div>
      </div>

      <div className="flex space-x-2 pt-4 border-t border-gray-200">
        <button
          onClick={() => onEdit(product)}
          className="flex-1 btn btn-secondary flex items-center justify-center space-x-2 text-sm"
        >
          <Edit2 className="w-4 h-4" />
          <span>Edit</span>
        </button>
        <button
          onClick={() => onDelete(product.id)}
          className="flex-1 btn btn-danger flex items-center justify-center space-x-2 text-sm"
        >
          <Trash2 className="w-4 h-4" />
          <span>Delete</span>
        </button>
      </div>
    </div>
  )
}

export default ProductCard
