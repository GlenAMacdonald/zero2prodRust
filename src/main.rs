use secrecy::ExposeSecret;
use zero2prod::{configuration::get_configuration, startup::run};
use zero2prod::telemetry::{get_subscriber, init_subscriber};
use std::net::TcpListener;
use sqlx::PgPool;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let subscriber = get_subscriber("zero2prod".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration.");
    // connect_lazy only tries to establish a connection when the pool is used for the first time
    let connection_pool = PgPool::connect_lazy(
            &configuration.database.connection_string().expose_secret()
        )
        .expect("Failed to connect to Postgres.");
    let address = format!("{}:{}", configuration.application.host, configuration.application.port);
    let listener = TcpListener::bind(address)?;
    run(listener, connection_pool)?.await
}
