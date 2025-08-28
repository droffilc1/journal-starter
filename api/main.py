from contextlib import asynccontextmanager
from fastapi import FastAPI
from dotenv import load_dotenv
from prometheus_fastapi_instrumentator import Instrumentator
from api.controllers import journal_router
import logging

load_dotenv()

# Configure logging to print logs to the console
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(name)s - %(levelname)s - %(message)s",
    handlers=[logging.StreamHandler()],
)

logger = logging.getLogger(__name__)

# Create the FastAPI app
app = FastAPI()

# Attach Prometheus instrumentation BEFORE the app starts
Instrumentator().instrument(app).expose(app)

# Include routes
app.include_router(journal_router, prefix="/api/v1")


# Lifespan only handles startup/shutdown logs now
@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Startup complete. Metrics exposed.")
    yield
    logger.info("Shutdown complete.")


# Rebind app with lifespan handling
app.router.lifespan_context = lifespan

logger.info("FastAPI application created successfully")

