require('dotenv').config()
const express = require('express')
const cors = require('cors')
const helmet = require('helmet')

const app = express()
const PORT = process.env.PORT || 3000

// Middleware
app.use(helmet())
app.use(cors())
app.use(express.json())

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'ok', message: 'Server is running' })
})

// API Routes
app.get('/api', (req, res) => {
    res.json({
        message: 'Production & Maintenance Tracker API',
        version: '1.0.0',
        endpoints: {
            assets: '/api/assets',
            tasks: '/api/tasks',
            users: '/api/users'
        }
    })
})

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).json({
        error: 'Something went wrong!',
        message: process.env.NODE_ENV === 'development' ? err.message : undefined
    })
})

// 404 handler
app.use((req, res) => {
    res.status(404).json({ error: 'Route not found' })
})

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`)
    console.log(`📍 Environment: ${process.env.NODE_ENV || 'development'}`)
    console.log(`🔗 Health check: http://localhost:${PORT}/health`)
})

module.exports = app
