/**
 * MiroslavSec Portfolio - Enhancements
 */

(function () {
    'use strict';

    // Smooth scroll for anchor links (fallback for browsers that need it)
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href === '#') return;
            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // Subtle card entrance on scroll (optional enhancement)
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, observerOptions);

    function observeCard(el) {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        observer.observe(el);
    }

    document.querySelectorAll('.lab-card, .video-card, .thm-path-card, .proof-card, .track-card').forEach(observeCard);

    // Load videos from data/videos.json (commit to repo when you publish a lab video)
    const videoGrid = document.getElementById('video-grid');
    const filtersWrap = document.getElementById('video-filters');
    const videoCount = document.getElementById('video-count');
    if (videoGrid) {
        fetch('data/videos.json')
            .then(function (r) { return r.json(); })
            .then(function (videos) {
                if (videoCount) {
                    videoCount.textContent = String(videos.length);
                }

                function render(track) {
                    videoGrid.innerHTML = '';
                    var list = videos.filter(function (v) {
                        if (track === 'all') return true;
                        return (v.track || 'linux') === track;
                    });
                    if (list.length === 0) {
                        var empty = document.createElement('p');
                        empty.className = 'section-desc';
                        empty.innerHTML = 'No videos for this filter yet. Add entries with <code>track: &quot;' + escapeHtml(track) + '&quot;</code> in <code>data/videos.json</code>.';
                        videoGrid.appendChild(empty);
                        return;
                    }
                    list.forEach(function (v) {
                        var card = document.createElement('div');
                        card.className = 'video-card';
                        card.innerHTML =
                            '<div class="video-wrapper">' +
                            '<iframe loading="lazy" src="https://www.youtube.com/embed/' + v.id + '" title="' + escapeHtml(v.title) + '" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>' +
                            '</div><p>' + escapeHtml(v.title) + '</p>';
                        videoGrid.appendChild(card);
                        observeCard(card);
                    });
                }

                render('all');

                if (filtersWrap) {
                    filtersWrap.querySelectorAll('.video-filter').forEach(function (btn) {
                        btn.addEventListener('click', function () {
                            filtersWrap.querySelectorAll('.video-filter').forEach(function (b) {
                                b.classList.remove('active');
                            });
                            this.classList.add('active');
                            render(this.dataset.track || 'all');
                        });
                    });
                }
            })
            .catch(function () {
                videoGrid.innerHTML = '<p class="section-desc">Videos load from <code>data/videos.json</code>. Run the site from the same origin or check the file.</p>';
            });
    }

    // Certifications grid with spotlight effect (data-driven for future additions)
    const certGrid = document.getElementById('cert-grid');
    if (certGrid) {
        fetch('data/certifications.json')
            .then(function (r) { return r.json(); })
            .then(function (certs) {
                certs.forEach(function (c) {
                    var card = document.createElement('article');
                    var status = (c.status || 'planned').toLowerCase();
                    var featured = !!c.featured;
                    var hasBadge = !!(c.badge);
                    card.className = featured
                        ? 'cert-card featured'
                        : (hasBadge ? 'cert-card has-badge' : 'cert-card');
                    card.setAttribute('tabindex', '0');
                    var meta = [];
                    if (c.hours) {
                        meta.push('<span class="cert-chip">' + escapeHtml(c.hours) + '</span>');
                    }
                    if (c.credential_id) {
                        meta.push('<span class="cert-chip cert-chip-id">' + escapeHtml(c.credential_id) + '</span>');
                    }
                    var mediaHtml = '';
                    if (featured && c.image) {
                        mediaHtml = '<div class="cert-media"><img src="' + escapeHtml(c.image) + '" alt="' + escapeHtml((c.title || 'Certificate') + ' preview') + '" loading="lazy"></div>';
                    } else if (hasBadge) {
                        mediaHtml = '<div class="cert-badge-wrap"><img class="cert-badge" src="' + escapeHtml(c.badge) + '" alt="' + escapeHtml((c.title || 'Badge') + ' badge') + '" loading="lazy"></div>';
                    }
                    card.innerHTML =
                        mediaHtml +
                        '<div class="cert-body">' +
                        '<div class="cert-top">' +
                        '<span class="cert-issuer">' + escapeHtml(c.issuer || 'Certification') + '</span>' +
                        '<span class="cert-status ' + escapeHtml(status) + '">' + (featured ? 'Featured' : escapeHtml(statusLabel(status))) + '</span>' +
                        '</div>' +
                        (featured ? '<p class="cert-kicker">Flagship path</p>' : '') +
                        '<h3 class="cert-title">' + escapeHtml(c.title || 'Untitled') + '</h3>' +
                        '<p class="cert-date">' + escapeHtml(c.date || 'TBD') + '</p>' +
                        (meta.length ? '<div class="cert-meta">' + meta.join('') + '</div>' : '') +
                        '<p class="cert-desc">' + escapeHtml(c.description || '') + '</p>' +
                        '<a class="cert-link" href="' + escapeHtml(c.credential_url || '#') + '" target="_blank" rel="noopener noreferrer">View credential</a>' +
                        '</div>';

                    attachSpotlight(card);
                    certGrid.appendChild(card);
                    if (featured) {
                        card.classList.add('visible');
                    } else {
                        observeCard(card);
                    }
                });
            })
            .catch(function () {
                certGrid.innerHTML = '<p class="section-desc">Certifications load from <code>data/certifications.json</code>.</p>';
            });
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function statusLabel(status) {
        if (status === 'earned') return 'Earned';
        if (status === 'progress') return 'In Progress';
        return 'Planned';
    }

    function attachSpotlight(el) {
        var rafId = null;
        var x = 0;
        var y = 0;

        el.addEventListener('mousemove', function (e) {
            var rect = el.getBoundingClientRect();
            x = e.clientX - rect.left;
            y = e.clientY - rect.top;
            if (rafId) return;
            rafId = requestAnimationFrame(function () {
                el.style.setProperty('--mx', x + 'px');
                el.style.setProperty('--my', y + 'px');
                rafId = null;
            });
        });
    }

    // Add visible class styles via JS to avoid extra CSS
    const style = document.createElement('style');
    style.textContent = '.lab-card.visible, .video-card.visible, .thm-path-card.visible, .proof-card.visible, .track-card.visible, .cert-card.visible { opacity: 1 !important; transform: translateY(0) !important; }';
    document.head.appendChild(style);
})();
