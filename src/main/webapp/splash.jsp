<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home - Food Delivery System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .bg-orange-gradient {
            background: linear-gradient(90deg, #f97316, #fdba74);
        }
        .fade-in {
            animation: fadeIn 1.5s ease-in-out;
        }
        @keyframes fadeIn {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .hover-scale {
            transition: transform 0.3s ease;
        }
        .hover-scale:hover {
            transform: scale(1.05);
        }
        .steps-card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .steps-card:hover {
            transform: translateY(-5px);
        }
        .video-player {
            border: 2px solid #ffffff;
            border-radius: 8px;
        }
        .slideshow-container {
            position: relative;
            width: 300px;
            height: 200px;
            border: 2px solid #ffffff;
            border-radius: 8px;
            overflow: hidden;
        }
        .slideshow-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            position: absolute;
            top: 0;
            left: 0;
            opacity: 0;
            transition: opacity 1s ease-in-out;
        }
        .slideshow-image.active {
            opacity: 1;
        }
        .play-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 10;
        }
        .play-overlay:hover {
            background: rgba(0, 0, 0, 0.7);
        }
        .play-overlay svg {
            width: 50px;
            height: 50px;
            fill: white;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white p-4 flex justify-between items-center shadow-md">
        <div class="flex items-center">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold text-yellow-500">Pizza Cow</span>
        </div>
        <nav class="space-x-4">

            <a href="aboutus.jsp" class="text-gray-600 hover:text-yellow-500">About</a>
            <a href="supportRequest.jsp" class="text-gray-600 hover:text-yellow-500">Contact</a>
            <a href="login.jsp" class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600">Start Ordering</a>
        </nav>
    </header>

    <!-- Main Section -->
    <main class="flex-grow bg-orange-gradient relative">
        <div class="container mx-auto py-16 flex items-center justify-between">
            <div class="w-1/3 flex flex-col space-y-4">
                <img src="<%=request.getContextPath()%>/assets/images/food-delivery-bag.jpg" alt="Takeaway Bag" class="w-40 h-60 object-cover fade-in hover-scale">
                <img src="<%=request.getContextPath()%>/assets/images/pizza.jpg" alt="Pizza" class="w-40 h-60 object-cover fade-in hover-scale">
            </div>
            <div class="w-1/3 flex justify-center relative">
                <div id="video-container" class="fade-in hover-scale relative">
                    <video id="promo-video" class="w-[300px] h-[200px] video-player" controls preload="metadata">
                        <source src="<%=request.getContextPath()%>/assets/videos/promo.mp4" type="video/mp4">
                        Your browser does not support the video tag.
                    </video>
                    <div id="play-overlay" class="play-overlay">
                        <svg viewBox="0 0 24 24">
                            <path d="M8 5v14l11-7z"/>
                        </svg>
                    </div>
                </div>
                <div id="slideshow-container" class="slideshow-container fade-in hover-scale hidden">
                    <img src="<%=request.getContextPath()%>/assets/images/food-delivery-bag.jpg" alt="Takeaway Bag" class="slideshow-image active">
                    <img src="<%=request.getContextPath()%>/assets/images/pizza.jpg" alt="Pizza" class="slideshow-image">
                    <img src="<%=request.getContextPath()%>/assets/images/salad.jpg" alt="Salad Bowl" class="slideshow-image">
                </div>
            </div>
            <div class="w-1/3 text-center text-white">
                <h1 class="text-4xl font-bold mb-4">Cravings? Covered.</h1>
                <p class="text-lg">With 20+ covered restaurants and dishes for every mood. Convenience has never tasted this good in your neighborhood!</p>
                <img src="<%=request.getContextPath()%>/assets/images/salad.jpg" alt="Salad Bowl" class="w-32 h-32 object-cover mt-6 fade-in hover-scale" style="margin-left: auto; margin-right: auto;">
            </div>
        </div>
    </main>

    <!-- Steps Section -->
    <section class="py-16 bg-white">
        <div class="container mx-auto max-w-md p-6 bg-white rounded-lg steps-card text-center">
            <h2 class="text-2xl font-bold text-gray-800 mb-4">Top 5: Eat, Repeat</h2>
            <div class="flex justify-center mb-4">
                <span class="text-4xl text-yellow-500">☀</span>
            </div>
            <ol class="text-left space-y-2 text-gray-600">
                <li>1. Pick a Restaurant</li>
                <li>2. Select Your Cravings</li>
                <li>3. Add the Details</li>
                <li>4. Place Your Order</li>
                <li>5. Sit back, Relax</li>
            </ol>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-orange-gradient p-4 text-white text-center">
        <div class="flex justify-center mb-2">
            <div class="w-10 h-10 bg-yellow-500 rounded-full flex items-center justify-center text-white font-bold">PC</div>
            <span class="ml-2 text-xl font-semibold">Pizza Cow</span>
        </div>
        <p class="text-sm">© 2025 Pizza Cow Inc. All Rights Reserved</p>
    </footer>

    <script>
        const video = document.getElementById('promo-video');
        const videoContainer = document.getElementById('video-container');
        const slideshowContainer = document.getElementById('slideshow-container');
        const playOverlay = document.getElementById('play-overlay');
        const images = slideshowContainer.querySelectorAll('.slideshow-image');
        let currentImageIndex = 0;

        function startSlideshow() {
            videoContainer.classList.add('hidden');
            slideshowContainer.classList.remove('hidden');
            setInterval(() => {
                images[currentImageIndex].classList.remove('active');
                currentImageIndex = (currentImageIndex + 1) % images.length;
                images[currentImageIndex].classList.add('active');
            }, 3000); // Change image every 3 seconds
        }

        // Handle video play event
        video.addEventListener('play', startSlideshow);

        // Handle overlay click as a fallback
        playOverlay.addEventListener('click', () => {
            const playPromise = video.play();
            if (playPromise !== undefined) {
                playPromise.catch(error => {
                    console.error('Video play failed:', error);
                    // Start slideshow even if video play fails
                    startSlideshow();
                });
            }
        });

        // Remove overlay when video starts playing
        video.addEventListener('playing', () => {
            playOverlay.style.display = 'none';
        });
    </script>
</body>
</html>