mod models;

use axum::{routing::get, Router};
// Remove the Server import as it's not needed
use sqlx::postgres::PgPoolOptions;
use std::env;
use tokio;
use std::net::SocketAddr;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Load environment variables
    dotenvy::dotenv().ok();

    // Read database URL from environment variable
    let database_url = env::var("DATABASE_URL")
        .map_err(|_| "DATABASE_URL must be set")?;

    println!("Database URL: {}", database_url);  // Add this line

    // Create a connection pool
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .map_err(|e| {
            eprintln!("Detailed error: {:?}", e);
            format!("Failed to create pool: {}", e)
        })?;

    // Build our application with a route
    let app = Router::new()
        .route("/", get(|| async { "Hello, World!" }))
        .with_state(pool);

    // Run it
    let port = env::var("PORT").unwrap_or_else(|_| "8000".to_string());
    let addr: SocketAddr = format!("0.0.0.0:{}", port).parse()?;
    println!("Listening on {}", addr);
    let listener = tokio::net::TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
