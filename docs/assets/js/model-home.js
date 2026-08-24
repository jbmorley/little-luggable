const RETURN_DELAY = 1000;
const RETURN_DURATION = 1500;

const TAU = 2 * Math.PI;

function easeInOutCubic(t) {
    return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
}

function shortestTurn(from, to) {
    const delta = (to - from) % TAU;
    if (delta > Math.PI) {
        return delta - TAU;
    }
    if (delta <= -Math.PI) {
        return delta + TAU;
    }
    return delta;
}

async function returnsHome(viewer) {
    await viewer.updateComplete;

    if (!viewer.loaded) {
        await new Promise((resolve) => {
            viewer.addEventListener('load', resolve, { once: true });
        });
    }

    const home = viewer.getCameraOrbit();
    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

    let holding = false;
    let timer = null;
    let frame = null;

    function stop() {
        if (frame !== null) {
            cancelAnimationFrame(frame);
            frame = null;
        }
        clearTimeout(timer);
        timer = null;
    }

    function goHome() {
        const from = viewer.getCameraOrbit();
        const turn = shortestTurn(from.theta, home.theta);
        const rise = home.phi - from.phi;
        const push = home.radius - from.radius;

        if (Math.abs(turn) < 1e-4 && Math.abs(rise) < 1e-4 && Math.abs(push) < 1e-4) {
            return;
        }

        function apply(progress) {
            const eased = easeInOutCubic(progress);
            const theta = from.theta + turn * eased;
            const phi = from.phi + rise * eased;
            const radius = from.radius + push * eased;

            viewer.cameraOrbit = `${theta}rad ${phi}rad ${radius}m`;
            viewer.jumpCameraToGoal();
        }

        if (reduceMotion.matches) {
            apply(1);
            return;
        }

        const start = performance.now();

        function step(now) {
            const progress = Math.min((now - start) / RETURN_DURATION, 1);
            apply(progress);
            frame = progress < 1 ? requestAnimationFrame(step) : null;
        }

        frame = requestAnimationFrame(step);
    }

    function scheduleReturn() {
        stop();
        if (!holding) {
            timer = setTimeout(goHome, RETURN_DELAY);
        }
    }

    viewer.addEventListener('pointerdown', () => {
        holding = true;
        stop();
    });

    for (const event of ['pointerup', 'pointercancel', 'pointerleave']) {
        viewer.addEventListener(event, () => {
            holding = false;
            scheduleReturn();
        });
    }

    viewer.addEventListener('camera-change', (event) => {
        if (event.detail.source === 'user-interaction') {
            scheduleReturn();
        }
    });
}

const viewer = document.querySelector('#model');

if (viewer) {
    returnsHome(viewer);
}
